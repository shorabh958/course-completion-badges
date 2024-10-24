module MyModule::CourseBadges {
    use aptos_framework::signer;
    use std::string::String;
    
    /// Struct representing a course completion badge
    struct Badge has store, key {
        course_name: String,
        issued_by: address,
        issue_date: u64,
    }

    /// Struct to track instructor status
    struct Instructor has key {
        is_active: bool
    }

    /// Error codes
    const E_NOT_INSTRUCTOR: u64 = 1;
    const E_ALREADY_HAS_BADGE: u64 = 2;

    /// Function to register a new instructor
    public fun register_instructor(account: &signer) {
        let instructor = Instructor {
            is_active: true
        };
        move_to(account, instructor);
    }

    /// Function for instructors to issue badges to students
    public fun issue_badge(
        instructor: &signer,
        student: &signer,
        course_name: String,
        timestamp: u64
    ) {
        // Verify instructor status
        let instructor_addr = signer::address_of(instructor);
        let student_addr = signer::address_of(student);
        
        assert!(
            exists<Instructor>(instructor_addr), 
            E_NOT_INSTRUCTOR
        );
        
        // Check if student already has badge
        assert!(
            !exists<Badge>(student_addr), 
            E_ALREADY_HAS_BADGE
        );

        // Create and issue new badge
        let badge = Badge {
            course_name,
            issued_by: instructor_addr,
            issue_date: timestamp,
        };
        
        // Move the badge to the student's account
        move_to(student, badge);
    }
}