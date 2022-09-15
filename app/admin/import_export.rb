require_relative '../../db/seeds_lib'
require_relative '../../db/unseeds'

ActiveAdmin.register_page "Import/Export" do
  content title: proc { I18n.t("active_admin.import_export") } do

    div class: "blank_slate_container" do
      span class: "blank_slate", style: "width: 400px" do
        span I18n.t("active_admin.import.top")
        small I18n.t("active_admin.import.warning")
        br
        small I18n.t("active_admin.import.body")
        br

        form method: "post", enctype: "multipart/form-data" do
          input name: :submission_type, value: "import", type: "hidden"
          input :authenticity_token, type: :hidden, name: :authenticity_token, value: form_authenticity_token

          input name: :file, type: "file", accept: ".yml,.yaml"
          input value: I18n.t("active_admin.import.upload"), type: "submit"
        end
      end
    end

    br

    div class: "blank_slate_container" do
      span class: "blank_slate", style: "width: 400px" do
        span I18n.t("active_admin.export.top")
        small I18n.t("active_admin.export.body")
        br

        form method: "post" do
          input name: :submission_type, value: "export", type: "hidden"
          input :authenticity_token, type: :hidden, name: :authenticity_token, value: form_authenticity_token

          input value: I18n.t("active_admin.export.link_text"), type: "submit"
        end
      end
    end
  end

  controller do
    def post
      def redirect_error(message = nil)
        error_message = message.nil? ? 'Database import failed' : message

        redirect_to(
          { action: :index },
          flash: { error: error_message })
      end

      def redirect_success
        redirect_to(
          { action: :index },
          notice: 'Database import succeeded!')
      end

      if request.params[:submission_type].nil?
        redirect_error
      elsif request.params[:submission_type] == "import"
        begin
          unparsed_yaml = request.params[:file].read
          parsed_yaml = YAML::load(unparsed_yaml)
          replace_records(parsed_yaml)
          redirect_success
        rescue => e
          redirect_error e.message
        end
      elsif request.params[:submission_type] == "export"
        send_data fetch_records.to_yaml, filename: "database.yml"
      else
        redirect_error
      end
    end
  end
end
