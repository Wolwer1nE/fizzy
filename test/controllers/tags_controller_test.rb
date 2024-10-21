require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "create with existing tag" do
    assert_no_difference -> { accounts(:"37s").tags.count } do
      post bucket_bubble_tags_url(buckets(:writebook), bubbles(:logo)), params: { tag: { title: "Web" } }
    end

    assert_redirected_to bubbles(:logo)
  end

  test "create with new tag" do
    assert_difference -> { accounts(:"37s").tags.count }, +1 do
      post bucket_bubble_tags_url(buckets(:writebook), bubbles(:logo)), params: { tag: { title: "Horizons" } }
    end

    assert_redirected_to bubbles(:logo)
    assert bubbles(:logo).tags.pluck(:title).include?("Horizons")
  end
end
