advice = "Few things in life are as important as house training your pet dinosaur."
p advice.index("house") # =ｐ> 39
p advice.slice(0, advice.index("house"))
p advice
p advice.slice!(0, advice.index("house"))
p advice
