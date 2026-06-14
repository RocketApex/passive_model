require "test_helper"
require "open3"
require "rbconfig"

class ContactForm < PassiveModel::Base
  attr_accessor :first_name, :last_name

  validates :first_name, presence: true
  validates :last_name, presence: true
end

class SourceCallbackForm < PassiveModel::Base
  attr_reader :callback_runs

  before_save :record_callback

  def record_callback
    @callback_runs = true
  end
end

class TargetCallbackForm < PassiveModel::Base
end

class PassiveModelTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::PassiveModel::VERSION
  end

  def test_plain_require_can_define_a_passive_model_class
    lib_path = File.expand_path("../lib", __dir__)
    ruby_lib = [lib_path, ENV["RUBYLIB"]].compact.join(File::PATH_SEPARATOR)
    script = <<~RUBY
      require "passive_model"
      abort "ActiveRecord was loaded" if defined?(ActiveRecord)

      class ScriptContactForm < PassiveModel::Base
        attr_accessor :name

        validates :name, presence: true
      end

      abort "invalid" unless ScriptContactForm.new(name: "Jey").valid?
    RUBY

    _stdout, stderr, status = Open3.capture3(
      { "RUBYLIB" => ruby_lib },
      RbConfig.ruby,
      "-e",
      script
    )

    assert_predicate status, :success?, stderr
  end

  def test_validations_work
    form = ContactForm.new(last_name: "Doe")

    refute form.valid?
    assert_includes form.errors[:first_name], "can't be blank"
  end

  def test_save_returns_false_for_invalid_objects
    form = ContactForm.new(last_name: "Doe")

    assert_equal false, form.save
  end

  def test_save_returns_true_for_valid_objects
    form = ContactForm.new(first_name: "John", last_name: "Doe")

    assert_equal true, form.save
  end

  def test_save_bang_raises_passive_model_validation_error_for_invalid_objects
    form = ContactForm.new

    error = assert_raises(PassiveModel::ValidationError) { form.save! }

    assert_kind_of ActiveModel::ValidationError, error
    assert_equal form, error.model
    refute_match(/\AActiveRecord::/, error.class.name)
  end

  def test_before_save_callbacks_do_not_leak_between_subclasses
    source = SourceCallbackForm.new
    target = TargetCallbackForm.new

    assert_equal true, source.save
    assert_equal true, source.callback_runs
    assert_equal true, target.save
  end
end
