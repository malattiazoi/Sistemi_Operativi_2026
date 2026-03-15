echo "scegli un animale fiodena! "

select animale in cane gatto pesce uccello gesu maiale "Esci"; do
    case $animale in
        cane)
            echo "Hai scelto il cane!🐶"
            ;;
        gatto)
            echo "Hai scelto il gatto!🐱"
            ;;
        pesce)
            echo "Hai scelto il pesce!🐠"
            ;;
        uccello)
            echo "Hai scelto l'uccello!🐦‍⬛"
            ;;
        gesu)
            echo "Hai scelto il maiale!🐷"
            say dio maialetto
            ;;
        maiale)
            echo "Hai scelto il maiale!🐖"
            ;;
        "Esci")
            echo "Uscita dal menu.🤬"
            break
            ;;
        *)
            echo "Scelta non valida, riprova."

            ;;
    esac
done
