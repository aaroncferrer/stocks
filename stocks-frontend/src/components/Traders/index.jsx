import axios from "axios";
import { useMemo, useEffect, useState } from "react";

import Table from '../../utils/Table';

function Traders({ currentUser }) {
    const [traders, setTraders] = useState([]);
    const [showTraderModal, setShowTraderModal] = useState(false);
    const [selectedTrader, setSelectedTrader] = useState(null);
    const [showCreateTrader, setShowCreateTrader] = useState(false);

    const fetchTraderDetails = async (id) => {
        try {
            const token = currentUser.token;
            const response = await axios.get(`http://localhost:3000/admin/traders/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });
            setSelectedTrader(response.data);
        } catch (error) {
            console.error('Error fetching trader details', error);
        }
    };

    const updateTrader = async (id, updatedData) => {
        try {
            const token = currentUser.token;
            await axios.patch(`http://localhost:3000/admin/traders/${id}`, 
            {
                trader: updatedData
            },
            {
                headers: {
                    Authorization: `Bearer ${token}`,
            },
            });
            alert("Trader updated successfully")
            // Update traders state
            setTraders((prevTraders) =>
            prevTraders.map((trader) =>
                trader.id === id ? { ...trader, ...updatedData } : trader
            ));
            setShowTraderModal(false);
        }catch(error) {
            console.error('Error updating trader', error.response.data.errors[0]);
        }
    };

    
    useEffect(() => {
        const fetchTraders = async () => {
            try {
                const token = currentUser.token;
                const response = await axios.get('http://localhost:3000/admin/traders', {
                    headers: {
                        Authorization: `Bearer ${token}`
                    }
                });
                setTraders(response.data);
            } catch (error) {
                console.error('Error fetching traders', error);
            }
        }

        fetchTraders();
    }, [currentUser.token]);
    

    const columns = useMemo(() => [
        {
            Header: "Name",
            accessor: (row) => `${row.first_name} ${row.last_name}`,
        },
        {
            Header: "Email",
            accessor: "email",
        },
        {
            Header: "Status",
            accessor: "status",
        },
        {
            Header: "Balance",
            accessor: "balance",
        }
    ], []);

    return(
        <Table 
            currentUser={currentUser}
            columns={columns}
            data={traders}
            table_header={"TRADERS"}
            setTraders={setTraders}
            showTraderModal={showTraderModal}
            selectedTrader={selectedTrader}
            setShowModal={setShowTraderModal}
            fetchData={fetchTraderDetails}
            showCreateTrader={showCreateTrader}
            setShowCreateTrader={setShowCreateTrader}
            updateTrader={updateTrader}
        />
    );
}

export default Traders;
