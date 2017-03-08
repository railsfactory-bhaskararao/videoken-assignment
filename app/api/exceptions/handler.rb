module Exceptions
  module Handler
    extend ActiveSupport::Concern
  
    included do
      rescue_from ActiveRecord::RecordNotFound do |e|
        error!({message: e.message, status: 404})
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        error!({message: 'Unprocessible entity.', errors: e.record.errors.messages, status: 422})
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({message: e.message, status: 400})
      end

      rescue_from NameError do |e|
      	error!({message: e.message, status: 400})
      end

      # When all else fails...
      rescue_from :all do |e|
        Rails.logger.error "\n#{e.class.name} (#{e.message}):"
        e.backtrace.each { |line| Rails.logger.error line }
        error_response(message: 'Internal server error', status: 500)
      end
    end
  end
end