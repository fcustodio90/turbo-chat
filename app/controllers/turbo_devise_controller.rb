class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      if @default_response
        @default_response.call(options.merge(formats: :html))
      else
        controller.render(options.merge(formats: :html))
      end
    rescue ActionView::MissingTemplate => error
      if get?
        raise error
      elsif has_errors? && default_action
        if respond_to?(:error_rendering_options, true)
          # For responders 3.1.0 or higher
          render error_rendering_options.merge(formats: :html, status: :unprocessable_entity)
        else
          render rendering_options.merge(formats: :html, status: :unprocessable_entity)
        end
      else
        navigation_behavior error
      end
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end