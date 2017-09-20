class TransitController < ApplicationController
  def show
    url = URI.parse('')
    @line = params[:id]
  end
end
