# frozen_string_literal: true

class UploadListSerializer < ApplicationSerializer
  attributes :id,
             :user_id,
             :original_filename,
             :filesize,
             :width,
             :height,
             :url,
             :created_at,
             :updated_at,
             :origin,
             :extension

  has_many :upload_references, embed: :object, serializer: UploadReferencesSerializer

  def filesize
    if object.filesize >= 1_000_000
      "#{(object.filesize / 1024.00 / 1024.00).round(2)} MB"
    elsif object.filesize >= 1_000
      "#{(object.filesize / 1024.00).round(2)} KB"
    else
      "#{(object.filesize).round(2)} B"
    end
  end
end
