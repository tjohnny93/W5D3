require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'byebug'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    if already_built_response?
      raise "already rendered"
    else
      @res.status = 302
      @res.location = url
      @already_built_response = true
    end

  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    if already_built_response?
      raise "already rendered"
    else 
      res['Content-Type'] = content_type
      res.write(content)
      @already_built_response = true
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    
    dir_path = File.dirname(__FILE__) 
    # debugger
    template_path = File.join(
        dir_path,
        "..",
        "views",
        self.class.name.underscore,
        "#{template_name}.html.erb"
        )
        # debugger
    returned_code = File.read(template_path)
   jam = (ERB.new(returned_code).result(binding))
   render_content(jam, "text/html")
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

