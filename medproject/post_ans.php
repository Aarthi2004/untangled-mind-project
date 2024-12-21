<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once('db.php');

$response = array();
$status = false; // Initialize status as false

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the JSON data from the request body
    $json_data = file_get_contents("php://input");

    // Decode the JSON data
    $data = json_decode($json_data, true);

    // Check if required fields are present
    if (isset($data['userId'], $data['Score']) && is_array($data['Score'])) {
        // Get user ID
        $userId = $data['userId'];

        try {
            // Get current date
            $date = date('Y-m-d');

            // Prepare and execute SQL statements
            $stmt = $conn->prepare("INSERT INTO answers (user_id, question_id, user_answer, date) VALUES (?, ?, ?, ?)");

            // Prepare and execute SQL statement for questionnaire_scorecard
            $scoreStmt = $conn->prepare("INSERT INTO questionarie_scorecard (user_id, date, total_score, A, B, C, D, E) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

            // Define a mapping of options to scores
            $scoreMapping = array('Every day' => 4, 'Most days' => 3, 'Some days' => 2, 'Very rarely' => 1, 'Never' => 0);

            // Initialize counts
            $counts = array('Every day' => 0, 'Most days' => 0, 'Some days' => 0, 'Very rarely' => 0, 'Never' => 0);

            $totalScore = 0;

            foreach ($data['Score'] as $score) {
                // Check if required fields are present in each score entry
                if (isset($score['Questionids'], $score['Answer'])) {
                    // Get question ID and submitted answer
                    $questionId = $score['Questionids'];
                    $submittedAns = $score['Answer'];

                    // Bind parameters and execute for answers table
                    $stmt->bind_param("iiss", $userId, $questionId, $submittedAns, $date);
                    $stmt->execute();

                    // Update counts
                    $counts[$submittedAns]++;
                    
                    // Calculate total score based on the selected options
                    $totalScore += isset($scoreMapping[$submittedAns]) ? $scoreMapping[$submittedAns] : 0;
                } else {
                    // Set missing fields error message in response
                    $response['error'] = 'Missing required fields in score entry';
                    $response['status'] = false;
                    $responseStr = json_encode($response);
                    echo $responseStr;
                    exit(); // Terminate the script
                }
            }

            // Bind parameters and execute for questionnaire_scorecard
            $scoreStmt->bind_param("issiiiii", $userId, $date, $totalScore, $counts['Every day'], $counts['Most days'], $counts['Some days'], $counts['Very rarely'], $counts['Never']);
            $scoreStmt->execute();

            // Set success message and update status
            $response['message'] = 'Answers submitted successfully';
            $status = true;
        } catch (PDOException $e) {
            // Set database error message in response
            $response['error'] = 'Database error: ' . $e->getMessage();
        }
    } else {
        // Set missing fields error message in response
        $response['error'] = 'Missing required fields';
    }
} else {
    // Set method not allowed error message in response
    $response['error'] = 'Method Not Allowed';
}

// Include status in the response
$response['status'] = $status;

// Respond with the JSON-encoded response
$responseStr = json_encode($response);
echo $responseStr;
?>
