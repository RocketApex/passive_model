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

The current implementation copies each key directly to an instance variable. For
example, `first_name: "Lewis"` sets `@first_name`. Define `attr_accessor`,
`attr_reader`, or explicit methods for values you need to read later.

This assignment style does not call custom setters and does not reject unknown
attribute names.

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

`save` validates the object. If the object is invalid, it returns `false`.

```ruby
form = ContactForm.new(last_name: "Doe")

form.save # => false
```

If the object is valid, `save` runs registered `before_save` callbacks and
returns `true`. In the current implementation, valid objects without a registered
`before_save` callback may fail instead of returning `true`; see "Current
Implementation Notes".

### Save Bang

`save!` calls `save` and raises `ActiveRecord::RecordInvalid` when the object
cannot be saved.

```ruby
form = ContactForm.new

form.save! # raises ActiveRecord::RecordInvalid
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

### persisted?

`persisted?` is intended to report whether `save` has been called successfully.
In the current implementation it returns `false` unless an instance sets
`@persisted` itself.

## Current Implementation Notes

These notes describe the current gem behavior and should be reviewed before
changing runtime code:

- `save` expects the callback storage to exist, so valid objects without a
  registered `before_save` callback may fail.
- `persisted?` does not currently switch to `true` after a successful `save`.
- `before_save` callbacks are stored in class-level shared storage.
- Attribute assignment writes instance variables directly instead of using
  ActiveModel attributes or custom setters.

## Contributing

For bug reports or feature requests, open an issue at
https://github.com/RocketApex/passive_model.
