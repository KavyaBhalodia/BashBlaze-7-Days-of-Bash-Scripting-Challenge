function view_systemmetrics
{
echo "SYSTEM METRICS"
cpu_usage=$(top -bn 1 | grep '%Cpu' | awk '{printf $2}')
mem_usage=$(free | grep Mem | awk '{printf("%.1f", $3f/$2 * 100)}' )
disk_usage=$(df -h / | tail -1 | awk '{printf $5}')

echo "CPU Usage: '$cpu_usage'  Memory Usage: '$mem_usage' Disk Usage '$disk_usage'"

}

function monitor_service()
{

echo "MONITOR A SPECIFIC SERVICE"
read -p "Enter the name of service you want to monitor" service_name
if systemctl is-active --quiet $service_name; then
        echo "'$service_name' is running."
else
        echo "'$service_name' is not running."
        read -p "Do you want to start '$service_name' ? (y/n):" choice
        if [ "$choice" = "Y" ]|| ["$choice" = "y"]; then
                systemctl start $service_name
                echo "'$service_name' started successfully."
        fi
fi
}

while true;do
        echo "MONITOR METRICS SCRIPTS"
        echo "1. View System Metrics"
        echo "2. Monitor a specific Service"
        echo "3. Exit"

        read -p "Enter your choice (1,2 or 3):" choice

        case $choice in
                1)
                        view_systemmetrics
                        ;;
                2)
                        monitor_service
                        ;;
                3)
                        echo "Exiting script."
                        exit 0
                        ;;
                *)
                        echo "Erro: Enter valid choice"
                        ;;
        esac

        sleep 5

done
