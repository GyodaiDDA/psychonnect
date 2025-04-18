class User < ApplicationRecord
  has_secure_password

  enum role: { pacient: 0, medic: 1 }
end
