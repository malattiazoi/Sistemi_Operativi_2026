echo "Scegli un animale:"
PS3='>>:'
select animale in cane gatto pappagallo pesce Esci; do
  case $animale in
    cane)
      echo "Hai scelto il cane 🐶"
      ;;
    gatto)
      echo "Hai scelto il gatto 🐱"
      ;;
    pappagallo)
      echo "Hai scelto il pappagallo 🦜"
      ;;
    pesce)
      echo "Hai scelto il pesce 🐟"
      ;;
    Esci)
      echo "Ciao!"
      break
      ;;
    *)
      echo "Scelta non valida!"
      ;;
  esac
done
