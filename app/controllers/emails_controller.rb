# frozen_string_literal: true

class EmailsController < ApplicationController
  def index
    @emails = Email.with_associations.recent.limit(50)
  end

  def show
    @email = Email.with_associations.find(params[:id])
  end
end
