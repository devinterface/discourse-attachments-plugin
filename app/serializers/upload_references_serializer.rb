# frozen_string_literal: true

class UploadReferencesSerializer < ApplicationSerializer
  attributes :target_type

  has_one :target, embed: :object, serializer: TargetSerializer
end
