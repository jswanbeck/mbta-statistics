class TransitController < ApplicationController
  def show
    url = URI.parse('')
    @type = params[:type]
    @line = params[:id]
  end
end
