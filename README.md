# PassiveModel

PassiveModel provides lightweight model objects for Rails applications when you
want ActiveModel-style behavior without a database table.

It is useful for form objects, service inputs, or other plain Ruby objects that
need validations, naming, translation, conversion, and callback hooks similar to
Active Record models.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "passive_model"
```

And then execute:

```sh
bundle install
```

Or install it yourself:

```sh
gem install passive_model
```

PassiveModel depends on ActiveModel 7.0 or newer. It does not depend on Rails or
ActiveRecord.

## Usage

Create a class that inherits from `PassiveModel::Base` and define the attributes
your object exposes.

```ruby
class ContactForm < PassiveModel::Base
  attr_accessor :first_name, :last_name

  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :first_name_is_not_spam

  private

  def first_name_is_not_spam
    return unless first_name.to_s.downcase == "test"

    errors.add(:first_name, "is not valid")
  end
end
```

### Creating Objects

Pass initial attributes to `.new`:

```ruby
form = ContactForm.new(first_name: "John", last_name: "Doe")
```

### Assigning Attributes

Assign multiple attributes with `attributes=`:

```ruby
form.attributes = { first_name: "Lewis" }
```

You can also call `form.assign_attributes(first_name: "Lewis")`. Both forms and
`.new` use ActiveModel to call the public setter for each field.

By default, a field without a public setter raises
`ActiveModel::UnknownAttributeError`. If you pass Rails controller parameters,
permit the fields for that form first.

### Validations

`PassiveModel::Base` includes ActiveModel validations, so standard Rails
validators work:

```ruby
form = ContactForm.new(last_name: "Doe")

form.valid? # => false
form.errors[:first_name] # => ["can't be blank"]
```

ActiveModel validation callbacks such as `before_validation` and
`after_validation` are also available.

### Save

`save` validates the object. If the object is invalid, it returns `false`. If the
object is valid, it runs registered `before_save` callbacks and returns `true`.

```ruby
invalid_form = ContactForm.new(last_name: "Doe")
valid_form = ContactForm.new(first_name: "John", last_name: "Doe")

invalid_form.save # => false
valid_form.save # => true
```

### Save Bang

`save!` calls `save` and raises `PassiveModel::ValidationError` when the object
cannot be saved. `PassiveModel::ValidationError` inherits from
`ActiveModel::ValidationError`; it does not require ActiveRecord.

```ruby
form = ContactForm.new

form.save! # raises PassiveModel::ValidationError
```

### before_save Callback

Register a `before_save` callback with the class method:

```ruby
class ContactForm < PassiveModel::Base
  attr_accessor :first_name

  validates :first_name, presence: true

  before_save :send_info_to_mailchimp

  private

  def send_info_to_mailchimp
    # API call
  end
end
```

The callback is executed only after validations pass.

`before_save` callbacks are stored per class, so callbacks registered on one
`PassiveModel::Base` subclass do not run for unrelated subclasses.

### persisted?

`persisted?` is intended to report whether `save` has been called successfully.
In the current implementation it returns `false` unless an instance sets
`@persisted` itself.

## Upgrading to 2.0

Review the fields you pass to `.new` and `attributes=` before upgrading.

- Give each field you intend to write a public setter. Use `attr_accessor` for
  a simple field or define the setter yourself.
- Remove extra keys before passing a hash. In Rails controllers, pass only
  parameters permitted for that form.
- Review any custom setters. PassiveModel now calls them during initialization
  and later assignment.

If you are upgrading from a version earlier than 1.1.0, also check any code that
rescues errors from `save!`. Since 1.1.0, a validation failure raises
`PassiveModel::ValidationError`.

## Contributing

For bug reports or feature requests, open an issue at
https://github.com/RocketApex/passive_model.
