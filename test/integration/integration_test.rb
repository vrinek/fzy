require 'minitest'
require 'minitest/autorun'
require 'ttytest'

class FzyTest < Minitest::Test
  FZY_PATH = File.expand_path('../../../fzy', __FILE__)

  def setup
    # fzy is fast.
    # This is never hit in a (passing) test suite, but helps speed up development
    TTYtest.default_max_wait_time = 0.2
  end

  def test_empty_list
    @tty = TTYtest.driver.new_terminal(%{echo placeholder;echo -n "" | fzy})
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, '>')
    @tty.assert_row(2, '')
    @tty.assert_cursor_position(y: 1, x: 2)

    @tty.send_keys('t')
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, '> t')
    @tty.assert_row(2, '')
    @tty.assert_cursor_position(y: 1, x: 3)

    @tty.send_keys('z')
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, '> tz')
    @tty.assert_row(2, '')
    @tty.assert_cursor_position(y: 1, x: 4)

    @tty.send_keys("\r")
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, 'tz')
    @tty.assert_cursor_position(y: 2, x: 0)
  end

  def test_one_item
    @tty = TTYtest.driver.new_terminal(%{echo placeholder;echo -n "test" | fzy})
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, '>')
    @tty.assert_row(2, 'test')
    @tty.assert_row(3, '')
    @tty.assert_cursor_position(y: 1, x: 2)

    @tty.send_keys('t')
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, '> t')
    @tty.assert_row(2, 'test')
    @tty.assert_row(3, '')
    @tty.assert_cursor_position(y: 1, x: 3)

    @tty.send_keys('z')
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, '> tz')
    @tty.assert_row(2, '')
    @tty.assert_row(3, '')
    @tty.assert_cursor_position(y: 1, x: 4)

    @tty.send_keys("\r")
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, 'tz')
    @tty.assert_cursor_position(y: 2, x: 0)
  end

  def test_two_items
    @tty = TTYtest.driver.new_terminal(%{echo placeholder;echo -n "test\nfoo" | fzy})
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, '>')
    @tty.assert_row(2, 'test')
    @tty.assert_row(3, 'foo')
    @tty.assert_row(4, '')
    @tty.assert_cursor_position(y: 1, x: 2)

    @tty.send_keys('t')
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, '> t')
    @tty.assert_row(2, 'test')
    @tty.assert_row(3, '')
    @tty.assert_cursor_position(y: 1, x: 3)

    @tty.send_keys('z')
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, '> tz')
    @tty.assert_row(2, '')
    @tty.assert_row(3, '')
    @tty.assert_cursor_position(y: 1, x: 4)

    @tty.send_keys("\r")
    @tty.assert_row(0, 'placeholder')
    @tty.assert_row(1, 'tz')
    @tty.assert_cursor_position(y: 2, x: 0)
  end
end
