import { useState } from 'react';
import Sidebar from '../../components/Sidebar';
import Stocks from '../../components/Stocks';
import Transactions from '../../components/Transactions';
import './adminDashboard.css'

function AdminDashboard({currentUser}){
    const [module, setModule] = useState(null);

    const handleModuleSelection = (moduleName) => {
        setModule(moduleName)
    }

    return(
        <section className="page">
            
            <Sidebar 
                currentUser={currentUser}
                module={module} 
                handleModuleSelection={handleModuleSelection}
            />
            {/* <article> */}
                {module === 'Stocks' && <Stocks currentUser={currentUser} />}
                {module === 'Transactions' && <Transactions currentUser={currentUser} />}  
            {/* </article> */}
        </section>
    )
}

export default AdminDashboard;