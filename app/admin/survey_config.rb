ActiveAdmin.register SurveyConfig do
    permit_params :value
    actions :index, :show, :new, :create, :update, :edit

    index do
        selectable_column
        id_column
        column :name
        column :value
        actions
    end

    filter :name
    filter :value

    form do |f|
        f.inputs do
            f.input :name, input_html:{disabled:true}
            f.input :value
        end
        f.actions
    end
end