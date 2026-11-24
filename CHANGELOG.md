# Changelog

## 2.0.0

- Use ActiveModel for assignment through `.new`, `attributes=`, and
  `assign_attributes`. These methods call public setters.
- Raise `ActiveModel::UnknownAttributeError` by default when a field has no
  public setter. Rails controller parameters must be permitted before
  assignment.
- See [Upgrading to 2.0](README.md#upgrading-to-20) for migration steps.

## 1.1.0 - 2026-06-14

- Require `active_model` directly when loading `passive_model`, so the gem boots
  without relying on the host Rails application to preload ActiveModel.
- Replace the broad `rails` runtime dependency with `activemodel`.
- Align the gem's Ruby requirement with ActiveModel 7.
- Change `save!` to raise `PassiveModel::ValidationError`, an
  `ActiveModel::ValidationError` subclass, instead of
  `ActiveRecord::RecordInvalid`.
- Store `before_save` callbacks per subclass so callbacks do not leak between
  unrelated `PassiveModel::Base` subclasses.
- Add focused tests for independent boot, validations, `save`, `save!`, and
  callback isolation.
