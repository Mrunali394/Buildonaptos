module FreelancePlatform::JobManagement {

    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a freelance job.
    struct Job has store, key {
        payment: u64,          // Payment for the job
        is_completed: bool,    // Status of job completion
    }

    /// Function to create a new job with a specified payment amount.
    public fun create_job(freelancer: &signer, payment: u64) {
        let job = Job {
            payment,
            is_completed: false,
        };
        move_to(freelancer, job);
    }

    /// Function for a client to approve the job and release payment to the freelancer.
    public fun approve_job(client: &signer, freelancer: address) acquires Job {
        let job = borrow_global_mut<Job>(freelancer);

        assert!(!job.is_completed, 1); // Ensure the job isn't already completed

        // Use client to withdraw the payment
        let payment = coin::withdraw<AptosCoin>(client, job.payment);
        coin::deposit<AptosCoin>(freelancer, payment);

        // Mark the job as completed
        job.is_completed = true;
    }
}
