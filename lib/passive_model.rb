require "passive_model/version"
require "active_model"

module PassiveModel
  class Error < StandardError; end
  class ValidationError < ActiveModel::ValidationError; end
end

require "passive_model/base"
