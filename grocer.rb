require 'pry'

def consolidate_cart(cart)
  new_hash = {}
  cart.each do |single_hash|
    single_hash.each do |key, value|
      if new_hash[key] #if this is a duplicate, just add 1 to count
        new_hash[key][:count] += 1
      else #if not a duplicate, have to create a new key
        new_hash[key] = value
        new_hash[key][:count] = 1 #and need to create key of count
      end
    end
  end
  new_hash
end


def apply_coupons(cart, coupons)
  # iterate through coupons
    #binding.pry
  coupons.each do |coupon| # for each coupon
    item_name = coupon[:item] #access item in cart
    if cart["#{item_name} W/COUPON"] && coupon[:num] <= cart[item_name][:count]
        cart["#{item_name} W/COUPON"][:count] += coupon[:num]
        cart[item_name][:count] -= coupon[:num]
    elsif cart[item_name] && coupon[:num] <= cart[item_name][:count] #check if relevant item in cart #and that coupon num is less than or equal to item count
      cart["#{item_name} W/COUPON"] = { # if coupon can apply, create item name with coupon key
          # make it's value a new object with values of
          :price => coupon[:cost] / coupon[:num], #cost divided by number of items required by coupon
          :clearance => cart[item_name][:clearance],
          :count => coupon[:num]
      }
      cart[item_name][:count] -= coupon[:num] #after we've applied coupon to number specified by coupon, need to subtract that number by cart
    end
  end
  #lab doesn't really specify return value of method which is confusing
  #now see they want cart and new_hash combined...ahhh
  #actually is shown in directions
  #and errors were that couldn't access key b/c trying to call keys from seperate hashes in same hash
  cart
end

def apply_clearance(cart)
  # if clearance is true, reduce price by 20 percent
  # use float round method...just .round
  cart.each do |item, values|
    #binding.pry
    if values[:clearance]
      values[:price] = (values[:price] * 0.8).round(1)
    end
  end
end

def checkout(cart, coupons)
  consolidate_cart = consolidate_cart(cart) #why is this functioning like apply_coupons/adding w/coupon, so weird
  coupons_applied_cart = apply_coupons(consolidate_cart, coupons)
  clearance_applied_cart = apply_clearance(coupons_applied_cart)
  total = 0.0
  clearance_applied_cart.each do |item, values|
    total += (values[:price] * values[:count]) #forgot to mulitply by count! thought it was issue with consolidate cart but wasnt
  end
  if total > 100
    total *= 0.9
  end
  total
end
