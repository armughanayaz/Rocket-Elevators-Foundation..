class Lead < ApplicationRecord
     belongs_to :customers, optional: true
end
