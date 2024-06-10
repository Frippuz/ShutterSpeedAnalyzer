function [shutter_speed, num_exposures] = calculate_shutter_speed(video, shot_fps)

    exposed_frames = 0;
    numframes = video.NumFrames;
    means = zeros(numframes,1);
    
    for i = 1:numframes
        frame = readFrame(video);
        frame = rgb2gray(frame);
        
        light_mean = mean(frame(:));
        means(i) = light_mean;
    end
    
    threshold = mean(means);
    
    for j = 1:length(means)
        if means(j) >= threshold
            exposed_frames = exposed_frames + 1;
        end
    end
    
    % Adjdust threshold if num_exposures does not match with the number of visible peaks.
    [peaks, locs] = findpeaks(means, 'MinPeakProminence', threshold * 0.1); 

    % Display the number of exposed frames
    %disp(['Exposed Frames: ', num2str(exposed_frames)]);

    shutter_speed = exposed_frames/shot_fps/length(locs);
    num_exposures = length(locs);

    % Plot the mean light intensity over time with detected peaks
    figure;
    plot(means, 'x-', 'LineWidth', 1.5); % Improved plot command
    hold on;
    yline(threshold, 'r--', 'Threshold'); % Add label to the yline
    plot(locs, peaks, 'rv', 'MarkerFaceColor', 'r'); % Highlight peaks with red downward triangles
    xlabel('Frame Number');
    ylabel('Mean Light Intensity');
    title('Mean Light Intensity Over Time');
    grid on;
    grid minor;
    legend('Mean Intensity', 'Threshold', 'Peaks');
    hold off;

end