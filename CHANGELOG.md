# Changelog

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
