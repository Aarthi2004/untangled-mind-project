<?php
// Initialize response array
$response = array();
require_once('db.php'); // Include db.php to establish the database connection

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Get POST data
    $post_data = file_get_contents('php://input');

    // Decode POST data into an array
    $post_data_array = json_decode($post_data, true);

    // Check if subtopic details are provided
    if (isset($post_data_array['subtopic_id'], $post_data_array['subtopic_name'], $post_data_array['questions'])) {
        // Get subtopic details
        $subtopic_id = $post_data_array['subtopic_id'];
        $subtopic_name = $post_data_array['subtopic_name'];
        $questions = $post_data_array['questions'];

        // Prepare the insert statement
        $insert_question_query = "INSERT INTO video_questions (subtopic_id, subtopic_name, question_id, question, option_a, option_b, option_c, option_d) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        $insert_question_stmt = $conn->prepare($insert_question_query);

        if ($insert_question_stmt) {
            // Loop through each question
            foreach ($questions as $question) {
                $question_id = $question['question_id'];
                $question_text = $question['question'];
                $option_a = $question['option_a'];
                $option_b = $question['option_b'];
                $option_c = $question['option_c'];
                $option_d = $question['option_d'];

                // Bind parameters for the current question
                $insert_question_stmt->bind_param("ssssssss", $subtopic_id, $subtopic_name, $question_id, $question_text, $option_a, $option_b, $option_c, $option_d);

                // Execute the question statement
                if ($insert_question_stmt->execute()) {
                    // Question added successfully
                    $response["success"] = true;
                    $response["message"] = "Questions added successfully";
                } else {
                    // Error inserting question
                    $response["success"] = false;
                    $response["message"] = "Error inserting question: " . $insert_question_stmt->error;
                    // If one question fails, break the loop
                    break;
                }
            }

            // Close the statement after the loop
            $insert_question_stmt->close();
        } else {
            // Error preparing statement
            $response["success"] = false;
            $response["message"] = "Error preparing statement: " . $conn->error;
        }
    } else {
        // Subtopic details not provided
        $response["success"] = false;
        $response["message"] = "Subtopic details not provided";
    }
} else {
    // No POST data received
    $response["success"] = false;
    $response["message"] = "No POST data received";
}

// Output the response as JSON
header('Content-Type: application/json');
echo json_encode($response);
?>
