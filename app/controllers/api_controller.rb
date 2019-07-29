class ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken
  
  protected
end
