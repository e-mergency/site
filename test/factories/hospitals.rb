# Read about factories at https://github.com/thoughtbot/factory_girl

# This model initially had no columns defined.  If you add columns to the
# model remove the '{}' from the fixture names and add the columns immediately
# below each fixture, per the syntax in the comments below
#
#                 x Peters hospital
#                 |
#                 | 5km
#              1km|     5km
#             x---x ---------- x Florians hospital
# Kates hosptial  | simons hospital
#                 |
#                 |
#                 | 10km
#                 |
#                 |
#                 x Kushals hosptial

FactoryGirl.define do

  # The position is taken from the "Abbey Gisburne Park Hospital"
  factory :simons, class: Hospital do
    name "Simons Hospital"
    location [-2.2680899081386, 53.9431092443469]
    odscode 'SIMON'
  end

  # This hospital is 5km north of Simons hospital
  factory :peters, class: Hospital do
    name "Peters Hospital"
    location [-2.2680899081386, 53.9880753]
    odscode 'PETER'
  end

  # This hospital is 5km east of Simons hospital
  factory :florians, class: Hospital do
    name "Florians Hospital"
    location [-2.19192383, 53.9431092443469]
    odscode 'FLORIAN'
  end

  # This hospital is 1km west of Simons hospital
  factory :kates, class: Hospital do
    name "Kates Hospital"
    location [-2.28327634, 53.9431092443469]
    odscode 'KATE'
  end

  # This hospital is 10km south of Simons hospital
  factory :kushals, class: Hospital do
    name "Kushals Hospital"
    location [-2.2680899081386, 53.8531771]
    odscode 'KUSHAL'
  end

end
