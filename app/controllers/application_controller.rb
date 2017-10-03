class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include ApplicationHelper
  protect_from_forgery with: :exception
end


#Event.reflect_on_all_associations.select { |a| a.options[:dependent] == :destroy }.map(&:name)