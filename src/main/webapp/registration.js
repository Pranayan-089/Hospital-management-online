const sign_in_btn = document.querySelector("#sign-in-btn");
const sign_up_btn = document.querySelector("#sign-up-btn");
const container = document.querySelector(".container");

// Toggle between Sign in and Sign up forms
sign_up_btn.addEventListener("click", () => {
  container.classList.add("sign-up-mode");
});

sign_in_btn.addEventListener("click", () => {
  container.classList.remove("sign-up-mode");
});

// Show role-specific fields based on role selection
document.getElementById("role").addEventListener("change", function () {
  var role = this.value;

  // Hide all role-specific fields initially
  document.getElementById("doctor-fields").style.display = "none";
  document.getElementById("admin-fields").style.display = "none";
  document.getElementById("patient-fields").style.display = "none";
  document.getElementById("emergency-fields").style.display = "none";

  // Show fields based on selected role
  if (role === "doctor") {
    document.getElementById("doctor-fields").style.display = "block";
  } else if (role === "admin") {
    document.getElementById("admin-fields").style.display = "block";
  } else if (role === "patient") {
    document.getElementById("patient-fields").style.display = "block";
  } else if (role === "emergency") {
    document.getElementById("emergency-fields").style.display = "block";
  }
});

// Form validation
function validateForm() {
  var role = document.getElementById("role").value;

  // Check if the role is selected
  if (role === "Select Your Role") {
    alert("Please select a role.");
    return false;
  }

  // Validation for each role-specific section
  if (role === "doctor") {
    return validateDoctorForm();
  } else if (role === "admin") {
    return validateAdminForm();
  } else if (role === "patient") {
    return validatePatientForm();
  } else if (role === "emergency") {
    return validateEmergencyForm();
  }

  return true;
}

// Validation for doctor fields
function validateDoctorForm() {
  var name = document.getElementById("doc_name").value;
  var email = document.getElementById("doc_email").value;
  var pass = document.getElementById("doc_pass").value;
  var specialty = document.getElementById("doc_specialty").value;
  var experience = document.getElementById("doc_exp").value;
  var phone = document.getElementById("doc_num").value;
  var securityAnswer = document.getElementById("doc_sa").value;

  if (name === "" || email === "" || pass === "" || specialty === "" || experience === "" || phone === "" || securityAnswer === "") {
    alert("Please fill in all doctor fields.");
    return false;
  }

  return true;
}

// Validation for admin fields
function validateAdminForm() {
  var name = document.getElementById("admin_name").value;
  var email = document.getElementById("admin_email").value;
  var pass = document.getElementById("admin_pass").value;
  var phone = document.getElementById("admin_no").value;
  var securityAnswer = document.getElementById("admin_sa").value;

  if (name === "" || email === "" || pass === "" || phone === "" || securityAnswer === "") {
    alert("Please fill in all admin fields.");
    return false;
  }

  return true;
}

// Validation for patient fields
function validatePatientForm() {
  var name = document.getElementById("pat_name").value;
  var email = document.getElementById("pat_email").value;
  var pass = document.getElementById("pat_pass").value;
  var securityAnswer = document.getElementById("pat_sa").value;

  if (name === "" || email === "" || pass === "" || securityAnswer === "") {
    alert("Please fill in all patient fields.");
    return false;
  }

  return true;
}

// Validation for emergency service fields
function validateEmergencyForm() {
  var name = document.getElementById("emer_name").value;
  var email = document.getElementById("emer_email").value;
  var pass = document.getElementById("emer_pass").value;
  var securityAnswer = document.getElementById("emer_sa").value;

  if (name === "" || email === "" || pass === "" || securityAnswer === "") {
    alert("Please fill in all emergency service fields.");
    return false;
  }

  return true;
}
