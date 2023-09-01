import Sidebar from "../../components/Sidebar";

function TraderDashboard({currentUser}) {
    return(
        <section className="page">
            
            <Sidebar currentUser={currentUser} />

            <article>

            </article>
        </section>
    )
}

export default TraderDashboard;