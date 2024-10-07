#!/bin/bash

mkdir -p /home/ubuntu/custom-metrics

cat << 'EOF' > /home/ubuntu/custom-metrics/loadaverage.sh
#!/bin/bash

while true; do
    CPU_CORES=$(nproc)
    LOAD_AVG_5_MIN=$(cat /proc/loadavg | awk '{print $2}')
    
    if [ "$CPU_CORES" -ne 0 ]; then
        LOAD_AVG_PERCENT=$(echo "scale=2; ($LOAD_AVG_5_MIN / $CPU_CORES) * 100" | bc)
    else
        LOAD_AVG_PERCENT=0
    fi

    aws cloudwatch put-metric-data \
        --metric-name LoadAveragePercentage \
        --dimensions AutoScalingGroup=terraform-asg \
        --namespace "CustomMetrics" \
        --value $LOAD_AVG_PERCENT \
        --unit Percent

    sleep 60
done
EOF

chmod +x /home/ubuntu/custom-metrics/loadaverage.sh

nohup /home/ubuntu/custom-metrics/loadaverage.sh > /home/ubuntu/custom-metrics/loadaverage.log 2>&1 &

