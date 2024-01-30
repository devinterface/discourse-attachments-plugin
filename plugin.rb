# name: attachments-list
# about: Plugin to add attachments list feature to admin section
# version: 1.0.0
# authors: Devinterface Srl
# url: https://code.devinterface.com/AssoImprese/discourse-attachments-plugin.git


add_admin_route 'attachments.title', 'attachments'

Discourse::Application.routes.append do
  get "/admin/plugins/attachments" => "admin/attachments#index"
  get "/admin/attachments" => "admin/attachments#index"
end



after_initialize do
  module ::AttachmentsList
    PLUGIN_NAME ||= "attachments-list"

    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace AttachmentsList
    end

    class Error < StandardError
    end
  end

  require_relative "app/controllers/admin/attachments_controller.rb"
  require_relative "app/lib/upload_index_query.rb"
  require_relative "app/serializers/target_serializer.rb"
  require_relative "app/serializers/upload_references_serializer.rb"
  require_relative "app/serializers/upload_list_serializer.rb"
end
