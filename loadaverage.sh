#!/bin/bash

while true; do
    # Get the number of CPU cores
    CPU_CORES=$(nproc)

    # Get the 5-minute load average
    LOAD_AVG_5_MIN=$(cat /proc/loadavg | awk '{print $2}')

    # Calculate load average as a percentage
    if [ "$CPU_CORES" -ne 0 ]; then
        LOAD_AVG_PERCENT=$(echo "scale=2; ($LOAD_AVG_5_MIN / $CPU_CORES) * 100" | bc)
    else
        LOAD_AVG_PERCENT=0
    fi

    # Publish to CloudWatch
    aws cloudwatch put-metric-data \
        --metric-name LoadAveragePercentage \
        --dimensions AutoScalingGroup=terraform-asg \
        --namespace "CustomMetrics" \
        --value $LOAD_AVG_PERCENT \
        --unit Percent

    sleep 60
done

