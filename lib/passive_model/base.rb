# frozen_string_literal: true

module PassiveModel
  # Class to be a parent class for all model-like classes where you need validations etc
  # To be used for forms and to be mapped to each form independently
  # Behaves like a active record model without the corresponding table
  # Supports before_validation after_validation callbacks
  # Supports before_save (gets run only if valid) - this is a custom implementation
  # Supports passing the attributes .new and .attributes
  class Base
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    def initialize(hash = {})
      set_attributes(hash)
    end

    def attributes=(hash = {})
      set_attributes(hash)
    end

    def save
      return false unless self.valid?

      execute_callbacks(@@before_save_callbacks)
      true
    end

    def save!
      raise(ActiveRecord::RecordInvalid) unless self.save
    end

    def persisted?
      @persisted || false
    end

    private

    def execute_callbacks(callbacks)
      (callbacks || []).each do |callback|
        self.send(callback.to_sym)
      end
    end

    def self.before_save(name)
      @@before_save_callbacks ||= []
      @@before_save_callbacks << name unless @@before_save_callbacks.include?(name)
    end

    def set_attributes(hash)
      hash.keys.each do |key|
        instance_variable_set('@' + key.to_s, hash[key])
      end
    end
  end
end
