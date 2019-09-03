require './test/test_helper'
require './lib/middleman-gemoji/converter'

module Middleman
  class Application
    attr_reader :root
    attr_accessor :config

    def initialize
      @config = OpenStruct.new(
        source: 'source',
        http_prefix: ''
      )
    end

    def root
      ENV['MM_ROOT']
    end
  end
end

class TestConverter < Minitest::Test
  def setup
    @root = ENV['MM_ROOT']
    ENV['MM_ROOT'] = File.join(Dir.pwd, 'fixtures', 'gemoji-file-exist')
    @converter = converter
  end

  def teardown
    ENV['MM_ROOT'] = @root
  end

  def converter(app: Middleman::Application.new, size: nil, style: nil, emoji_dir: 'images/emoji')
    Middleman::Gemoji::Converter.new(app, {size: size, style: style, emoji_dir: emoji_dir})
  end

  def test_initialize
    assert_instance_of(Middleman::Application, @converter.app)
  end

  def test_initialize_raise_runtime_error
    assert_raises RuntimeError do
      converter(app: nil)
    end
  end

  def test_convert_received_blank
    assert_equal('', @converter.convert(''))
    assert_nil(@converter.convert(nil))
  end

  def test_emojify
    assert_equal(
      '<img class="gemoji" alt="+1" src="/images/emoji/unicode/1f44d.png" />',
      @converter.emojify(':+1:')
    );
  end

  def test_emojify_received_normal_string
    html = '<p>hoge</p>'
    assert_equal(html, @converter.emojify(html));
  end

  def test_emojify_inner_body
    html = "<html><head><title>something title :+1:</title></head><body>\n<p>somethig emoji :+1:</p>\n</body></html>"
    result = @converter.emojify_inner_body(html)
    assert_match(/1f44d.png/, result)
    assert_match(/something title :\+1:/, result)
  end

  def test_emojify_inner_body_received_normal_string
    html = '<p>hoge</p>'
    assert_equal(html, @converter.emojify_inner_body(html))
  end

  def test_has_body_return_true
    html = <<-'HTML'
      <!doctype html>
      <html>
        <head>
          <meta charset="utf-8">
          <title>something title :+1:</title>
        </head>
        <body>
          <p>:+1:</p>
        </body>
      </html>
    HTML
    assert_equal(true, @converter.has_body?(html))
  end

  def test_has_body_return_true__body_has_class
    html = <<-'HTML'
      <!doctype html>
      <html>
        <head>
          <meta charset="utf-8">
          <title>something title :+1:</title>
        </head>
        <body class="index">
          <p>:+1:</p>
        </body>
      </html>
    HTML
    assert_equal(true, @converter.has_body?(html))
  end

  def test_has_body_return_false
    html = '<p>somethig emoji :+1:</p>'
    assert_equal(false, @converter.has_body?(html))
  end

  def test_src
    path = @converter.src('unicode/1f44d.png')
    assert_equal('src="/images/emoji/unicode/1f44d.png"', path)
  end

  def test_src_with_cdn
    ENV['MM_ROOT'] = File.join(@converter.app.root, 'fixtures', 'gemoji-file-not-exist')
    @converter.set_base_path
    path = @converter.src('unicode/1f44d.png')
    assert_equal(
      'src="https://assets-cdn.github.com/images/icons/emoji/unicode/1f44d.png"',
      path
    )
  end

  def test_size_return_nil
    @converter.options[:size] = nil
    assert_nil(@converter.size)
  end

  def test_size_return_string
    @converter.options[:size] = 40
    assert_equal('width="40" height="40"', @converter.size)
  end

  def test_style_return_nil
    @converter.options[:style] = nil
    assert_nil(@converter.style)
  end

  def test_style_return_string
    @converter.options[:style] = 'padding-right: .2em'
    assert_equal('style="padding-right: .2em"', @converter.style)
  end

  def test_emoji_file_exist_return_true
    assert_equal(true, @converter.emoji_file_exist?)
  end

  def test_emoji_file_exist_return_false
    ENV['MM_ROOT'] = File.join(@converter.app.root, 'fixtures', 'gemoji-file-not-exist')
    assert_equal(false, @converter.emoji_file_exist?)
  end

  def test_set_base_path__cdn
    ENV['MM_ROOT'] = File.join(@converter.app.root, 'fixtures', 'gemoji-file-not-exist')
    @converter.set_base_path
    assert_equal(
      'https://assets-cdn.github.com/images/icons/emoji/',
      @converter.base_path
    )
  end

  def test_set_base_path__relative_path
    assert_equal('/images/emoji', @converter.base_path)
  end

  def test_set_base_path__full_path
    @converter.app.config[:http_prefix] = 'http://example.com/'
    @converter.set_base_path
    assert_equal('http://example.com/images/emoji', @converter.base_path)
  end
end
