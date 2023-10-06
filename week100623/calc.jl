## Lopsided League computation
## Written by Charlie 
x = 103210 
function factorial_to_num(x)
    digit = digits(x)
    val  = 0 
    for i = 1:length(digit)
        val_temp = factorial(i) * digit[i]
        val += val_temp 

    end
    return val 
end

num = factorial_to_num(x)
print(num)

function check_divisible(x, y)
    return x % y == 0
end 

function check_divisible_through_5(x)
    for i = 1:5
        if check_divisible(x,i) == false
            return false 
        end
    end
    return true 
end 


function check_digits(x)
    digit = digits(x)
    for i = 1:5
        if (i in digit) == false
            return false 
        end
    end
    return true 
end 


function valid_factorial_num(x)
    digit = digits(x)
    if digit[1] > factorial(0) 
        return false
    elseif digit[2] > factorial(1) 
        return false 
    elseif digit[3] > factorial(2) 
        return false 
    elseif digit[4] > factorial(3) 
        return false 
    else 
        return true 
    end
end 

done = 0 
i = 100000
while done < 1
    if valid_factorial_num(i)
        if check_digits(i)
            num = factorial_to_num(x)
            if check_divisible_through_5(num)
                print(i)
                done = 1
            end
        end
    end
    i += 1

end
