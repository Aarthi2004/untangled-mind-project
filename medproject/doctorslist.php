<?php
error_reporting(0);
require_once('db.php');
error_reporting(E_ALL);
ini_set('display_errors', 1);

$response = array();

try {
    // Check if the request method is GET
    if ($_SERVER["REQUEST_METHOD"] === "GET") {
        // SQL query to fetch user information including the image path
        $sql = "SELECT user_id, Name, Age, doctorimage FROM Doctor";

        // Prepare the SQL query
        $stmt = $conn->prepare($sql);

        // Execute the query
        $stmt->execute();

        // Get the result set from the prepared statement
        $result = $stmt->get_result();

        // Fetch all rows as an associative array
        $data = $result->fetch_all(MYSQLI_ASSOC);

        // Process each row to convert image to base64
        foreach ($data as &$row) {
            $imagePath = $row['doctorimage'];
            // Read the image file from the path
            $imageData = file_get_contents($imagePath);
            if ($imageData !== false) {
                // Convert the image data to base64 encoding
                $base64Image = base64_encode($imageData);
                // Update the row with the base64 encoded image
                $row['doctorimage'] = $base64Image;
            } else {
                // Set a placeholder value if image reading fails
                $row['doctorimage'] = null;
            }
        }

        if (count($data) > 0) {
            $response['status'] = true;
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
