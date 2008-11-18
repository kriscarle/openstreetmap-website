require File.dirname(__FILE__) + '/../test_helper'

class WayTagTest < Test::Unit::TestCase
  fixtures :current_way_tags
  set_fixture_class :current_way_tags => WayTag
  
  def test_way_tag_count
    assert_equal 3, WayTag.count
  end
  
  def test_length_key_valid
    key = "k"
    (0..255).each do |i|
      tag = WayTag.new
      tag.id = current_way_tags(:t1).id
      tag.k = key*i
      tag.v = current_way_tags(:t1).v
      assert_valid tag
    end
  end
  
  def test_length_value_valid
    val = "v"
    (0..255).each do |i|
      tag = WayTag.new
      tag.id = current_way_tags(:t1).id
      tag.k = "k"
      tag.v = val*i
      assert_valid tag
    end
  end
  
  def test_length_key_invalid
    ["k"*256].each do |i|
      tag = WayTag.new
      tag.id = current_way_tags(:t1).id
      tag.k = i
      tag.v = "v"
      assert !tag.valid?, "Key #{i} should be too long"
      assert tag.errors.invalid?(:k)
    end
  end
  
  def test_length_value_invalid
    ["k"*256].each do |i|
      tag = WayTag.new
      tag.id = current_way_tags(:t1).id
      tag.k = "k"
      tag.v = i
      assert !tag.valid?, "Value #{i} should be too long"
    end
  end
  
  def test_empty_tag_invalid
    tag = WayTag.new
    assert !tag.valid?, "Empty way tag should be invalid"
    assert tag.errors.invalid?(:id)
  end
  
  def test_uniquess
    tag = WayTag.new
    tag.id = current_way_tags(:t1).id
    tag.k = current_way_tags(:t1).k
    tag.v = current_way_tags(:t1).v
    assert tag.new_record?
    assert !tag.valid?
    assert_raise(ActiveRecord::RecordInvalid) {tag.save!}
    assert tag.new_record?
  end
end
