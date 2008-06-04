class EiqScaffoldGenerator < Rails::Generator::NamedBase

  default_options :skip_timestamps => false, :skip_migration => false

  attr_reader   :controller_name,
  :controller_class_path,
  :controller_file_path,
  :controller_class_nesting,
  :controller_class_nesting_depth,
  :controller_class_name,
  :controller_underscore_name,
  :controller_singular_name,
  :controller_plural_name
  alias_method  :controller_file_name,  :controller_underscore_name
  alias_method  :controller_table_name, :controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = @name.pluralize

    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name=base_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions(controller_class_path, "#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_path, "#{class_name}")

      # Controller, helper, views, and test directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      #m.directory(File.join('app/views/layouts', controller_class_path))
      m.directory(File.join('test/functional', controller_class_path))
      m.directory(File.join('test/unit', class_path))

      for action in scaffold_views
        m.template(
        "view_#{action}.html.erb",
        File.join('app/views', controller_class_path, controller_file_name, "#{action}.html.erb")
        )
      end

      # Layout and stylesheet.
      m.template('_form.html.erb', File.join('app/views', controller_class_path, controller_file_name, "_form.html.erb"))

      # Layout admin e partials do admin
      m.template('admin.html.erb', 'app/views/layouts/admin.html.erb')
      m.template('_admin_head.html.erb', 'app/views/layouts/_admin_head.html.erb')
      m.template('_admin_menu.html.erb', 'app/views/layouts/_admin_menu.html.erb')
      m.template('_admin_rodape.html.erb', 'app/views/layouts/_admin_rodape.html.erb')

      # CSS do admin
      m.template('admin.css', 'public/stylesheets/admin.css')

      # Imagens do CSS
      m.template('images/button_add.gif', 'public/images/button_add.gif')
      m.template('images/button_back.gif', 'public/images/button_back.gif')
      m.template('images/button_cancel.gif', 'public/images/button_cancel.gif')
      m.template('images/button_delete.gif', 'public/images/button_delete.gif')
      m.template('images/button_edit.gif', 'public/images/button_edit.gif')
      m.template('images/button_help.gif', 'public/images/button_help.gif')
      m.template('images/button_key.gif', 'public/images/button_key.gif')
      m.template('images/button_msg_alert.gif', 'public/images/button_msg_alert.gif')
      m.template('images/button_music.gif', 'public/images/button_music.gif')
      m.template('images/button_no.gif', 'public/images/button_no.gif')
      m.template('images/button_ok.gif', 'public/images/button_ok.gif')
      m.template('images/button_ok2.gif', 'public/images/button_ok2.gif')
      m.template('images/button_photo.gif', 'public/images/button_photo.gif')
      m.template('images/button_restrito.gif', 'public/images/button_restrito.gif')
      m.template('images/button_save.gif', 'public/images/button_save.gif')
      m.template('images/button_video.gif', 'public/images/button_video.gif')
      m.template('images/button_view.gif', 'public/images/button_view.gif')
      m.template('images/button_view2.gif', 'public/images/button_view2.gif')
      m.template('images/hover.gif', 'public/images/hover.gif')
      m.template('images/pass.gif', 'public/images/pass.gif')
      m.template('images/user.gif', 'public/images/user.gif')
      # fim imagens

      m.dependency 'model', [name] + @args, :collision => :skip

      m.template(
      'controller.rb', File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )

      m.template('functional_test.rb', File.join('test/functional', controller_class_path, "#{controller_file_name}_controller_test.rb"))
      m.template('helper.rb',          File.join('app/helpers',     controller_class_path, "#{controller_file_name}_helper.rb"))

      m.route_resources controller_file_name
    end
  end

  protected
  # Override with your own usage banner.
  def banner
    "Usando: #{$0} eiq_scaffold NomeModel [campo:tipo, campo:tipo]"
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Opcoes:'
    opt.on("--skip-timestamps",
    "Nao adicione timestamps na migration para este model") { |v| options[:skip_timestamps] = v }
    opt.on("--skip-migration",
    "Nao criar a migration para este model") { |v| options[:skip_migration] = v }
  end

  def scaffold_views
    %w[ index show new edit ]
  end

  def model_name
    class_name.demodulize
  end
end
