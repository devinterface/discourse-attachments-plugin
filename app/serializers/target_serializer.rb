# frozen_string_literal: true

class TargetSerializer < ApplicationSerializer
  attributes :id, :slug, :title

  def include_slug?
    object.instance_of? Topic
  end

  def title
    if object.instance_of? Post
      object.topic.title
    elsif object.instance_of? User
      object.username
    elsif object.instance_of? UserAvatar
      object.user.username
    end
    # TODO: add other models if needed
  end
end
