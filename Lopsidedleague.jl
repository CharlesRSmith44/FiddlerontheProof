## Lopsided League computation
## Written by Charlie Smith

# Just two leagues 
N = 2 # number of leagues 
T = 5 # number of teams per league 
probs = rand(N,T)

function ind_higher(probs)
    if minimum(probs[1,:]) .> maximum(probs[2,:])
        return 1
    else
        return 0
    end 
end

function compute_prob(n,N,T)
    sum = 0 
    for i = 1:n
        probs = rand(N,T)
        sum = sum + ind_higher(probs)
    end
    return sum 
end 

n = 1e8 #number of times one league dominates the other 
share = compute_prob(n, N, T)/n
print(share) #approximately 0.003955

## Extra Credit 
N = 6 # number of leagues 
T = 5 # number of teams per league 

function ind_any_higher(probs)
    mins = zeros(N)
    maxs = zeros(N)
    for i = 1:N
        mins[i] = minimum(probs[i,:])
        maxs[i] = maximum(probs[i,:])
    end
    if minimum(maxs) < maximum(mins)
        return 1
    else
        return 0
    end 
end

function compute_prob_any(n,N,T)
    sum = 0 
    for i = 1:n
        probs = rand(N,T)
        sum = sum + ind_any_higher(probs)
    end
    return sum 
end 


n = 1e8 #number of times one league dominates the other 
share = compute_prob_any(n, N, T)/n
print(share) # approximately 0.08625

N = 2 # number of leagues 
T = 6 # number of teams per league 

strength = rand(N*T)
num_games = N*T-1 #number of games per team
rounds = 1 #number of times facing each team

function prob_win(x,y)
    return x/(x+y)
end

function loop_through_league(N,T,strength) 
    num_games = N*T-1
    wins = zeros(N*T,num_games)
    for i = 1:N*T
        for j =1:num_games
            if i+j <= N*T
                prob = prob_win(strength[i],strength[i+j])
                wins[i,j] = first(prob .> rand(1)) 
            end
        end
    end
    return wins
end

function compute_total_wins(rounds,N,T,strength)
    strength = rand(N*T)
    total_wins = zeros(N*T)
    for w = 1:rounds
        wins = loop_through_league(N,T,strength)
        total_wins = total_wins + sum(wins,dims=2) + Array{Float64}(0:N*T-1)
    end
    return total_wins
end 

total_wins = compute_total_wins(rounds,N,T,strength)


total_games = num_games*rounds
win_pct = total_wins/total_games 
