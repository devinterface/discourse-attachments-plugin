# frozen_string_literal: true

class Admin::AttachmentsController < ::Admin::AdminController
  requires_plugin AttachmentsList::PLUGIN_NAME

  def index
    uploads = ::UploadIndexQuery.new(params).find_uploads
    opts = {}
    render_serialized(uploads, UploadListSerializer, opts)
  end
end
