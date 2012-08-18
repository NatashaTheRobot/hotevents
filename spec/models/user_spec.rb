# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  expires_at :integer
#  first_name :string(255)
#  last_name  :string(255)
#  fb_id      :integer
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
