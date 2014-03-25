
type Menu
    choice::Int
end

function Menu()

    ShowMenu()
    choice=ReadChoice()
    #println(typeof(choice))
    @match choice begin
        #49 => {LinearAlgebra()}
        #49 => {require("home/abhijith/.julia/JuliaTutorial/src/LinearAlgebra.jl")}
        #50 => {include("MatrixFactorizations.jl")}
        #51 => {include("TextMining.jl")}
        #52 => {include("RecSys.jl")}
        49 => println("You can include the module by typing: using LinearAlgebra")
        50 => println("You can include the module by typing: using JuliaTutorial.MatrixFactoriations")
        51 => println("You can include the module by typing: using JuliaTutorial.TextMining")
        52 => println("You can include the module by typing: using JuliaTutorial.RecSys")
    end
end

function ShowMenu()

    println("Welcome to interactive Julia Tutorial series.")
    println("1.Linear Algebra.")
    println("2.Matrix Applications")
    println("3.Text Mining")
    println("4.Recommender Systems")
    println("Please select valid choice.")

end


function ReadChoice()
    
    cc=readbytes(STDIN,1) #choice is ascii of the value enetered
    
    #Check is the value of choice is between 1 and 4, i.e., 48 to 52
    cc=parseint("$cc")
    if cc < 49 || cc > 52
        Base.warn_once("Enter valid choice: 1,2,3,4")
        #println(choice)
        #ReadChoice()
    end
    return cc
    
end

#Menu()
println("Please use the method JuliaTutorial.Menu().")