# PassiveModel

This is a gem for using Rails ActiveModel functionalities without having an actual database table.

Supports validation, callbacks etc. And behaves like a model object, so can be replaced with actual model objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'passive_model'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install passive_model

## Usage

Create a class from `PassiveModel::Base`.

For example:

```erbruby
class ContactForm < PassiveModel::Base
  attr_accessor :first_name, :last_name

  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :first_name_is_not_spam
  
  private
  
  def first_name_is_not_spam
    return if first_name.downcase != 'test'

    errors.add(:first_name, 'is not valid')
  end
end
```

#### Create new objects 

`form = ContactForm.new(first_name: 'John', last_name: 'Doe')`

#### Set attributes

`form.attributes = { first_name: 'Lewis' }`

#### Emulate a save

It runs the validations and also calls `before_save` callbacks if the object is valid

`form.save # returns true if valid?`

#### Emulate a save!

Raise an error if cannot be saved

`form.save!`

#### persisted?

Return if save has been called

`form.persisted?`

#### before_save callback

Add a callback as follows:

```erbruby
class ContactForm < PassiveModel::Base
  before_save :send_info_to_mailchimp
  
  validate :first_name, presence: true
  
  private
  
  def send_info_to_mailchimp
    # API call  
  end
end
```

The callback will be executed only if validations are clear.

## Contributing

If you need more functionality, for bug reports raise a request at https://github.com/RocketApex/passive_model
