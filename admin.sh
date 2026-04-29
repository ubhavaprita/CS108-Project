#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # reset

touch users.txt
touch history.txt

while true; do
    clear
    echo -e "${BLUE}===== SYSTEM MENU =====${NC}"
    echo -e "${GREEN}1. Login${NC}"
    echo -e "${GREEN}2. Register${NC}"
    echo -e "${GREEN}3. Exit${NC}"
    echo ""

    read -p "Choose option: " opt

    if [[ "$opt" == "1" ]]; then
        break   # go to login
    elif [[ "$opt" == "2" ]]; then
    read -p "Enter new username: " new_user
    new_user=$(echo "$new_user" | xargs)

    if [[ -z "$new_user" || "$new_user" == *" "* || "$new_user" == *":"* ]]; then
        echo -e "${RED}Invalid username${NC}"
        sleep 2

    elif grep -q "^$new_user:" users.txt; then
        echo -e "${RED}Username already exists${NC}"
        sleep 2

    else
        echo "$new_user:user" >> users.txt
        echo -e "${GREEN}✔ User registered successfully${NC}"
        sleep 2
    fi

    elif [[ "$opt" == "3" ]]; then
        exit 0
    else
        echo -e "${RED}Invalid option${NC}"
        sleep 2
    fi
done

while true; do
    clear
    echo -e "${BLUE}--~~~--| LOG IN TO CONTINUE |--~~~--${NC}"
    echo ""
    echo "(Press Ctrl + C anytime to exit)"
    echo ""

    read -r -p "ENTER USERNAME - " user
    user=$(echo "$user" | xargs)

    line=$(grep "^${user}:" users.txt)

    if [ -z "$line" ]; then
    echo ""
    echo -e "${RED}User doesn't exist${NC}"
    echo ""
    echo "1. Change username"
    echo "2. Exit"
    read -r -p "Choose option: " num

    if [ "$num" = "1" ]; then
        continue
    elif [ "$num" = "2" ]; then
        echo "Exiting..."
        exit 0
    else
        echo -e "${RED}Invalid option${NC}"
        sleep 3
        continue   # 👈 ADD THIS
    fi
fi

    role=$(echo "$line" | cut -d ':' -f2 | tr -d '\r')

    while true; do
        clear
        echo -e "${BLUE}--~~~--| LOG IN TO CONTINUE |--~~~--${NC}"
        echo "(Press Ctrl + C anytime to exit)"
        echo ""
        echo "USERNAME: $user"
        echo ""


            echo -e "${GREEN}Welcome $user${NC}"
            sleep 1
        if [[ "$role" == "user" ]]; then
    while true; do
        clear
        echo -e "${BLUE}===== USER MENU =====${NC}"
        echo -e "${YELLOW}1. View my history${NC}"
        echo -e "${YELLOW}2. Exit${NC}"

        read -p "Choose: " uchoice

        if [[ "$uchoice" == "1" ]]; then
            if [[ ! -f "history.txt" ]]; then
                echo "history.txt not found."
            elif [[ ! -s "history.txt" ]]; then
                echo "No data available."
            else
                grep "] $user |" history.txt || echo -e "${RED}No records found${NC}"
            fi
            echo ""
            read -p "Press Enter..."
        elif [[ "$uchoice" == "2" ]]; then
            exit 0
        else
            echo -e "${RED}Invalid option${NC}"
            sleep 2
        fi
        done
        exit 0

        elif [[ "$role" == "admin" ]]; then
            echo -e "${GREEN}Welcome admin $user${NC}"
            sleep 1
            break 2
        else
            echo -e "${RED}Unknown role${NC}"
            sleep 2
            break
        fi
    else
           
            echo "1. Change username"
            echo "2. Exit"

            read -r -p "Choose option: " num

            elif [ "$num" = "1" ]; then
                break
            elif [ "$num" = "2" ]; then
                echo "Exiting..."
                exit 0
            else
                echo -e "${RED}Invalid option${NC}"
                sleep 3
            fi
        fi
    done
done
while true; do
    clear
    if [[ -f history.txt ]]; then
        awk -F'] ' '{print $2}' history.txt | cut -d '|' -f1 | sed 's/^ *//;s/ *$//' | while read u; do
            if [[ -n "$u" ]] && ! grep -q "^$u:" users.txt; then
                echo "$u:default:user" >> users.txt
                echo -e "${YELLOW}Auto-created user: $u${NC}"
            fi
        done
    fi

    echo ""
    echo -e "${BLUE}====== ADMIN DASHBOARD ======${NC}"
    echo ""
    echo -e "${YELLOW}1. View recent games${NC}"
    echo -e "${YELLOW}2. Filter by user${NC}"
    echo -e "${YELLOW}3. Analytics${NC}"
    echo -e "${YELLOW}4. Sort data${NC}"
    echo -e "${YELLOW}5. Log rotation${NC}"
    echo -e "${YELLOW}6. Delete entries${NC}"
    echo -e "${YELLOW}7. Exit${NC}"
    echo ""
    echo -e "${BLUE}=============================${NC}"
    read -r -p "Choose option: " choice
    if [[ "$choice" == "1" ]]; then
      clear
      if [[ ! -f "history.txt" ]]; then
          echo -e "${RED}history.txt not found${NC}"
      elif [[ ! -s "history.txt" ]]; then
          echo -e "${RED}No data available${NC}"
      else
          tail -n 10 history.txt
      fi
      echo ""
      read -p "Press Enter to continue..."
    elif [[ "$choice" == "2" ]]; then
        read -r -p "Enter username: " user
        user=$(echo "$user" | xargs)
        if [[ -z "$user" ]]; then
            echo -e "${RED}Username cannot be empty${NC}"
        elif [[ ! -f "history.txt" ]]; then
            echo -e "${RED}history.txt not found${NC}"
        elif [[ ! -s "history.txt" ]]; then
            echo -e "${RED}No data available${NC}"
        else
            grep "] $user |" history.txt || echo -e "${RED}No records found${NC}"
        fi
    echo ""
    read -p "Press Enter to continue..."
    elif [[ "$choice" == "3" ]]; then
        echo "Filter options:"
        echo ""
        echo "1.Full file"
        echo "2.Timestamp"
        read -r -p "Choose option: " choose
        if [[ "$choose" == "1" ]]; then

            if [[ ! -f "history.txt" ]]; then
                echo -e "${RED}history.txt not found${NC}"
            elif [[ ! -s "history.txt" ]]; then
                echo -e "${RED}No data available${NC}"
        else
        awk -F'|' '{
            score += $2
            duration += $4
            total++

            if ($2 > max_score) max_score = $2
            if (min_score == "" || $2 < min_score) min_score = $2

            if ($3 ~ /WALL/) wall++
            if ($3 ~ /SELF/) self++
        }
        END {
            if (total > 0) {
                printf "Total Games: %d\n", total
                printf "Mean Score: %.2f\n", score/total
                printf "Mean Duration: %.2f\n", duration/total

                printf "Max Score: %d\n", max_score
                printf "Min Score: %d\n", min_score

                printf "Wall Deaths: %d\n", wall
                printf "Self Deaths: %d\n", self

                printf "Wall Death Fraction: %.2f\n", wall/total

                if (wall > self)
                    print "Most Common Death: WALL"
                else if (self > wall)
                    print "Most Common Death: SELF"
                else
                    print "Most Common Death: Equal"
            } else {
                print "No valid data"
            }
        }' history.txt
        echo ""
        read -p "Press Enter to continue..."
        fi
        elif [[ "$choose" == "2" ]]; then
        echo "Timestamp format: YYYY-MM-DD HH:MM:SS"
        read -r -p "Enter timestamp: " ts
        awk -v ts="$ts" '
        match($0, /\[(.*?)\]/, t)
        t[1] <= ts
        ' history.txt | awk -F'|' '
        {
            score += $2
            duration += $4
            total++

            if ($2 > max_score) max_score = $2
            if (min_score == "" || $2 < min_score) min_score = $2

            if ($3 ~ /WALL/) wall++
            if ($3 ~ /SELF/) self++
        }
        END {
            if (total > 0) {
                printf "Total Games: %d\n", total
                printf "Mean Score: %.2f\n", score/total
                printf "Mean Duration: %.2f\n", duration/total

                printf "Max Score: %d\n", max_score
                printf "Min Score: %d\n", min_score

                printf "Wall Deaths: %d\n", wall
                printf "Self Deaths: %d\n", self
                printf "Wall Death Fraction: %.2f\n", wall/total
            } else {
                print "No valid data"
            }
        }
        '
    elif [[ "$choice" == "4" ]]; then
        echo "Option 4 selected"

    echo "Sort by:"
    echo "1. Username"
    echo "2. Score"
    echo "3. Timestamp (default)"
    read -r -p "Choose option: " sort_choice

    if [[ ! -f "history.txt" ]]; then
        echo -e "${RED}history.txt not found.${NC}"

    elif [[ ! -s "history.txt" ]]; then
        echo -e "${RED}No data available${NC}"

    else
        if [[ "$sort_choice" == "1" ]]; then
            sort -t '|' -k1 history.txt
        elif [[ "$sort_choice" == "2" ]]; then
            sort -t '|' -k2 -n history.txt
        else
            sort history.txt
        fi
    fi

    echo ""
    read -p "Press Enter to continue..."
    elif [[ "$choice" == "5" ]]; then
        echo "Option 5 selected"

    if [[ ! -f "history.txt" ]]; then
       echo -e "${RED}history.txt not found.${NC}"

    elif [[ ! -s "history.txt" ]]; then
        echo -e "{RED}No data available${NC}"

    else
        backup="history_$(date +%Y%m%d_%H%M%S).txt"
        cp history.txt "$backup"
        tail -n 10 history.txt > temp.txt
        mv temp.txt history.txt

        echo -e "${GREEN}✔ Log rotated successfully${NC}"
        echo -e "${GREEN}Backup saved as: $backup${NC}"
    fi
    echo ""
    read -p "Press Enter to continue..."
    elif [[ "$choice" == "6" ]]; then
        echo "Option 6 selected"
    echo "Delete options:"
    echo "1. Delete by username"
    echo "2. Delete invalid format entries"
    echo "3. Delete by timestamp"
    read -r -p "Choose option: " del_choice

    if [[ ! -f "history.txt" ]]; then
        echo -e "${RED}history.txt not found.${NC}"

    elif [[ ! -s "history.txt" ]]; then
        echo -e "{RED}No data available${NC}"

    else
        if [[ "$del_choice" == "1" ]]; then
            read -r -p "Enter username: " user
            user=$(echo "$user" | xargs)


            if [[ -z "$user" ]]; then
                echo -e "${RED}Username cannot be empty${NC}"
            else
                echo ""
                echo "Matching entries..."
                grep "] $user |" history.txt || echo -e "${RED}No records found${NC}"

                echo ""
                read -r -p "Confirm delete? (y/n): " confirm

                if [[ "$confirm" == "y" ]]; then

    line=$(grep -m 1 "^${user}:" users.txt)

    if [[ -z "$line" ]]; then
        echo -e "${RED}User not found in users.txt${NC}"
    else
        role=$(echo "$line" | cut -d ':' -f3)

        if [[ "$role" == "admin" ]]; then
            echo -e "${RED}Cannot delete admin user${NC}"
        else
            # delete from history
            sed -i "/] $user |/d" history.txt

            # delete from users
            sed -i "/^$user:/d" users.txt

            echo -e "${GREEN}User and all records deleted${NC}"
        fi
    fi

else
    echo -e "${YELLOW}Deletion cancelled${NC}"
fi
            fi

        elif [[ "$del_choice" == "2" ]]; then
            echo "This will remove improperly formatted lines."
            read -r -p "Confirm delete invalid entries? (y/n): " confirm

            if [[ "$confirm" == "y" ]]; then
                sed -i '/^\[[0-9]\{4\}-/!d' history.txt
                echo "Invalid entries removed."
            else
                echo "Cancelled."
            fi

        elif [[ "$del_choice" == "3" ]]; then
            read -r -p "Enter timestamp:" timestamp
            if [[ -z "$timestamp" ]]; then
                echo "timestamp cannot be empty"
            else
                echo ""
                echo "Matching entries..."
                grep "\[$timestamp\]" history.txt || echo "No records found"
                echo ""
                read -r -p "Confirm delete? (y/n): " confirm

                if [[ "$confirm" == "y" ]]; then
                    sed -i "/\[$timestamp\]/d" history.txt
                    echo "Entries deleted."
                else
                    echo "Deletion cancelled."
                fi
            fi

        else
            echo -e "${RED}Invalid option${NC}"
        fi
    fi

    echo ""
    read -p "Press Enter to continue..."

    elif [[ "$choice" == "7" ]]; then
        echo "Exiting..."
        exit 0
    else
        echo -e "${RED}Invalid option${NC}"
        sleep 1
        echo "Reloading Admin Dashboard"
        sleep 3
        fi
        fi
