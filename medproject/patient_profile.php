<?php
error_reporting(0);
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Create an associative array to hold the API response
$response = array();

try {
    // Check if the request method is GET
    if ($_SERVER["REQUEST_METHOD"] === "GET") {
        $userId = isset($_GET['user_id']) ? $_GET['user_id'] : null;
        // SQL query to fetch caretaker information including base64-encoded images
        $sql = "SELECT user_id, Name, phone_no, p_Name, Relationship, Diagnosis, Caretaker_image FROM Add_Caretakers";

        // Prepare the SQL query
        $stmt = $conn->prepare($sql);

        // Execute the query
        $stmt->execute();

        // Get the result set from the prepared statement
        $result = $stmt->get_result();

        // Fetch all rows as an associative array
        $data = $result->fetch_all(MYSQLI_ASSOC);

        if (count($data) > 0) {
            $response['status'] = true;
            // Decode the base64-encoded images
            foreach ($data as &$row) {
                $imagePath = $row['Caretaker_image'];
                
                // Check if the image file exists
                if (file_exists($imagePath)) {
                    // Read the image file
                    $imageData = file_get_contents($imagePath);

                    // Check if reading the image file was successful
                    if ($imageData !== false) {
                        // Encode the image data
                        $base64Image = base64_encode($imageData);
                        $row['Caretaker_image'] = $base64Image;
                    } else {
                        // Error reading the image file
                        $row['Caretaker_image'] = null;
                    }
                } else {
                    // Image file does not exist
                    $row['Caretaker_image'] = null;
                }
            }
            $response['data'] = $data;
        } else {
            $response['status'] = false;
            $response['message'] = "0 results";
        }
    } else {
        $response['status'] = false;
        $response['message'] = "Invalid request method. Only GET requests are allowed.";
    }
} catch (Exception $e) {
    // Handle any exceptions
    $response['status'] = false;
    $response['message'] = "Error: " . $e->getMessage();
} finally {
    // Close the statement and database connection
    $stmt->close();
    $conn->close();
}

// Convert the response array to JSON and echo it
header('Content-Type: application/json');
echo json_encode($response);
?>
